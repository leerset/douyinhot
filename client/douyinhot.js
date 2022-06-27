
function processAccount(jsonp) {
	// Make sure we only have one browser tab for this (sometimes there are stale tabs from prior runs)
	for (let i = gBrowser.browsers.length -1; i > 0 ; i--) {
		gBrowser.browsers[i].contentWindow.close();
	}
	CrawlerUtils.crawlerState = {
		onPageLoadCallback: Douyinhot.onPageLoad,
		crawlTimeout: 45000,
		run_key_id: jsonp.id,
		url: jsonp.url,
		processedVideos: jsonp.videos,
		videos: [],
		videoQueue: [],
		status: "user"
	};
	// video = {url: url, name: name, like: 0, comment: 0, attention: 0, release: 0}
	openUrl(jsonp.url);

	CrawlerUtils.guardedExecuteExceptionHandler = ( function(ex) {
		var message = "Failure in onPageLoad: " + ex.message;
		flog.error(message);
		flog.info(ex.stack);
		sendTicketStatus(message + ", stack: " + ex.stack);
		try {
			logOff();
		} catch (ex) {
			for (let i = gBrowser.browsers.length -1; i > 0 ; i--) {
				gBrowser.browsers[i].contentWindow.close();
			}
			SocketServer.errorExit("failure attempting to logoff");
		}
	});
}

function openUrl(url) {
	// globally disable window alert
	gBrowser.browsers[0].contentWindow.alert = function () { }
	gBrowser.browsers[0].contentWindow.location.href = url;
	SocketServer.sendToClient('info', "openUrl");
}

function sendStatus(status) {
	let message = {
		run_key_id: CrawlerUtils.crawlerState.run_key_id,
		status: status,
		videos: CrawlerUtils.crawlerState.videos,
	}
	SocketServer.sendToClient("status", message);
}

function setCurrentVideo() {
	CrawlerUtils.crawlerState.currentVideo = CrawlerUtils.crawlerState.videoQueue[0];
	CrawlerUtils.crawlerState.videoQueue = CrawlerUtils.crawlerState.videoQueue.slice(1);
	flog.debug("Processing video queue: " + CrawlerUtils.crawlerState.currentVideo + ", " + CrawlerUtils.crawlerState.videoQueue.length + " total remaining");
}

function processVideoQueue() {
	if (CrawlerUtils.crawlerState.videoQueue.length == 0) {
		flog.info("No more videos to do.");
		return;
	}

	setCurrentVideo();
	CrawlerUtils.crawlerState.status = "video";
	openUrl(CrawlerUtils.crawlerState.currentVideo);
}

function waitForRADeleteForm(window) {
	CrawlerUtils.waitForCondition(0, window, 15000, 1000, {
		condition: function() {
			return window.document.querySelector("textarea[name='remarks']");
		},
		callbackSuccess: function() {
			overrideWindowConfirm(window);
			window.document.querySelector("textarea[name='remarks']").value = 'Wrong form of payment';
			window.document.querySelector("input[value='Accept']").click();

			waitForRADeleteConfirmation(window);
		},
		callbackTimeout: function() {
			flog.error("RA details were not found");
			logOff();
		}
	});
}

function onPageLoad(window, timedout) {
	if (window.location.href.match(/^https:\/\/www.douyin.com\/user\//) && CrawlerUtils.crawlerState.status == "user") {
		CrawlerUtils.waitForCondition(0, window, 15000, 1000, {
			condition: function() {
				uls = window.document.querySelectorAll("ul.ARNw21RN");
				return uls.length > 0;
			},
			callbackSuccess: function() {
				lis = [].slice.call(window.document.querySelectorAll("ul.ARNw21RN li.ECMy_Zdt"));
				CrawlerUtils.crawlerState.videoQueue = lis.filter(function(li){
					videoUrl = li.querySelector("a").href;
					videoNumber = li.querySelector("a").href.replace(/.*\//,'');
					return !CrawlerUtils.crawlerState.processedVideos.includes(videoNumber);
				}).map(function(li){
					return li.querySelector("a").href;
				});
				processVideoQueue();
			},
			callbackTimeout: function() {
				SocketServer.errorExit("user page loading error");
			}
		});
	}
	else if (window.location.href.match(/^https:\/\/www.douyin.com\/video\//) && CrawlerUtils.crawlerState.status == "video") {
		CrawlerUtils.waitForCondition(0, window, 15000, 1000, {
			condition: function() {
				leftContainer = window.document.querySelector("div.leftContainer");
				hasNumbers = [].slice.call(leftContainer.querySelectorAll("div.kr4MM4DQ")).length == 4;
				hasRelease = leftContainer.querySelector("span.aQoncqRg").innerText.indexOf("发布时间") == 0;
				return leftContainer && hasNumbers && hasRelease;
			},
			callbackSuccess: function() {
				leftContainer = window.document.querySelector("div.leftContainer");
				numbers = [].slice.call(leftContainer.querySelectorAll("div.kr4MM4DQ"));
				video = {
					url: CrawlerUtils.crawlerState.currentVideo,
					name: leftContainer.querySelector("h1").innerText,
					like: numbers[0].innerText,
					comment: numbers[1].innerText,
					attention: numbers[2].innerText,
					release: leftContainer.querySelector("span.aQoncqRg").innerText,
				}
				CrawlerUtils.crawlerState.videos.push(video);
				processVideoQueue();
			},
			callbackTimeout: function() {
				SocketServer.errorExit("video page loading error");
			}
		});
	}
}
