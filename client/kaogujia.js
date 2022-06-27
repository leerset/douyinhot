// Kaogujia.processAccount({videos: [], url: "https://www.kaogujia.com/help"});

function addBorder(element, color = "#DC143C") {
	element.style = "border-color:" + color + ";border-width:1px;border-style:solid;";
  element.scrollIntoView();
}

function processAccount(jsonp) {
	// Make sure we only have one browser tab for this (sometimes there are stale tabs from prior runs)
	for (let i = gBrowser.browsers.length -1; i > 0 ; i--) {
		gBrowser.browsers[i].contentWindow.close();
	}
	CrawlerUtils.crawlerState = {
		onPageLoadCallback: Kaogujia.onPageLoad,
		crawlTimeout: 45000,
		url: "https://www.kaogujia.com/help",
		processedVideos: jsonp.videos,
		videos: [],
		videoQueue: [],
		status: "user",
		goodsList: [],
	};
	// video = {url: url, name: name, like: 0, comment: 0, attention: 0, release: 0}

	CrawlerUtils.guardedExecuteExceptionHandler = ( function(ex) {
		var message = "Failure in onPageLoad: " + ex.message;
		flog.error(message);
		flog.info(ex.stack);
		sendStatus(message + ", stack: " + ex.stack);
		try {
			logOff();
		} catch (ex) {
			for (let i = gBrowser.browsers.length -1; i > 0 ; i--) {
				gBrowser.browsers[i].contentWindow.close();
			}
			SocketServer.errorExit("failure attempting to logoff");
		}
	});

	openUrl(jsonp.url);
}

function logOff(){}

function openUrl(url) {
	// globally disable window alert
	gBrowser.browsers[0].contentWindow.alert = function () { }
	gBrowser.browsers[0].contentWindow.location.href = url;
	// SocketServer.sendToClient('info', "openUrl");
}

function sendKaoguStatus(status) {
	let message = {
		status: status,
		productions: CrawlerUtils.crawlerState.goodsList,
	}
	SocketServer.sendToClient("productions", message);
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

function login(window){
	btns = [].slice.call(window.document.querySelectorAll("button.el-button.el-button--primary"));
	Playback.playScript(window, [
		{type: 'delay', delay: 500},
		{type: 'mouse', element: btns[0]},
		{type: 'delay', delay: 500},
	], function() {
		qrButton = window.document.querySelector("div.changeBtn.qr");
		Playback.playScript(window, [
			{type: 'delay', delay: 500},
			{type: 'mouse', element: qrButton},
			{type: 'delay', delay: 500},
		], function() {
			CrawlerUtils.crawlerState.status = "password";
			inputPassword(window);
		})
	})
}

function inputPassword(window){
  inputs = window.document.querySelectorAll("input.el-input__inner");
  usernameEl=inputs[0];
  passwordEl=inputs[1];
  Playback.playScript(window, [
    {type: 'delay', delay: 500},
  	{type: 'mouse', element: usernameEl},
  	{type: 'delay', delay: 500},
  	{type: 'keyboard', str: "13725161888"},
  	{type: 'delay', delay: 500},
  	{type: 'mouse', element: passwordEl},
  	{type: 'delay', delay: 500},
  	{type: 'keyboard', str: "aBaCdG7939"},
  	{type: 'delay', delay: 500},
  ], function() {
  	btns = window.document.querySelectorAll("button.el-button.el-button--primary");
    Playback.playScript(window, [
    {type: 'delay', delay: 500},
    	{type: 'mouse', element: btns[1]},
    	{type: 'delay', delay: 500},
    ], function() {
      slider = window.document.querySelector("div#loginSlider span.btn_slide");
      rect = slider.getBoundingClientRect();
      x = rect.x; y = rect.y;
      Playback.playScript(window, [
        {type: 'delay', delay: 500},
        {type: 'mousedown', element: slider},
        {type: 'delay', delay: 500},
      ], function() {
				EventUtils.synthesizeMouseAtPoint(x + 10 + 400, y + 10, { type: "mousemove" }, window);
				EventUtils.synthesizeMouseAtPoint(x + 10 + 400, y + 10, { type: "mouseup" }, window);
				Playback.playScript(window, [
	        {type: 'delay', delay: 3000},
	      ], function() {
					CrawlerUtils.crawlerState.status = "videoRecommendList";
					window.location.href = "https://www.kaogujia.com/liveTopList/douyinProductList/videoRecommendList";
	      })
      })
    })
  });
}

function onPageLoad(window, timedout) {
	if (window.location.href.match(/^https:\/\/www.kaogujia.com\/help/) && CrawlerUtils.crawlerState.status == "user") {
		CrawlerUtils.waitForCondition(0, window, 15000, 1000, {
			condition: function() {
				btns = [].slice.call(window.document.querySelectorAll("button.el-button.el-button--primary"));
				avator = window.document.querySelector("div.component-nav-user span.el-avatar");
				return avator || btns.length == 1 && escape(btns[0].innerText) == '%u767B%u5F55/%u6CE8%u518C';
			},
			callbackSuccess: function() {
				btns = [].slice.call(window.document.querySelectorAll("button.el-button.el-button--primary"));
				avator = window.document.querySelector("div.component-nav-user span.el-avatar");
				if(btns.length == 1 && escape(btns[0].innerText) == '%u767B%u5F55/%u6CE8%u518C'){
					Playback.playScript(window, [
						{type: 'mouse', element: btns[0]},
						{type: 'delay', delay: 1000},
					], function() {
						qrButton = window.document.querySelector("div.changeBtn.qr");
						Playback.playScript(window, [
							{type: 'mouse', element: qrButton},
							{type: 'delay', delay: 1000},
						], function() {
							CrawlerUtils.crawlerState.status = "password";
							inputPassword(window);
						})
					})
				} else if (avator){
					CrawlerUtils.crawlerState.status = "videoRecommendList";
					window.location.href = "https://www.kaogujia.com/liveTopList/douyinProductList/videoRecommendList";
				} else {
					SocketServer.errorExit("user page loading error");
				}
			},
			callbackTimeout: function() {
				SocketServer.errorExit("user page loading error");
			}
		});
	}
	else if (window.location.href.match(/^https:\/\/www.kaogujia.com\/liveTopList\/douyinProductList\/videoRecommendList/) && CrawlerUtils.crawlerState.status == "videoRecommendList") {
		CrawlerUtils.waitForCondition(0, window, 15000, 5000, {
			condition: function() {
				tableRows = [].slice.call(window.document.querySelectorAll("table.el-table__body tr.el-table__row"));
				return tableRows.length > 0;
			},
			callbackSuccess: function() {
				tableRows = [].slice.call(window.document.querySelectorAll("table.el-table__body tr.el-table__row"));
				tableRows.map(function(row){
					tds = [].slice.call(row.querySelectorAll("td"));
					if (tds.length == 0)return null;
					oldPriceEl = tds[2].querySelector("del.oldPrice");
					rank = tds[0].innerText;
					if(tds[0].querySelector("h1.top1")) rank = "1";
					if(tds[0].querySelector("h1.top2")) rank = "2";
					if(tds[0].querySelector("h1.top3")) rank = "3";
					goods = {
						rank: rank,
						name: escape(tds[1].querySelector("div.productName").innerText),
						link: tds[1].querySelector("a").href,
						imageUrl: tds[1].querySelector("a img").src,
						nowPrice: tds[2].querySelector("span.nowPrice").innerText,
						oldPrice: oldPriceEl ? oldPriceEl.innerText : null,
						commissionRate: tds[3].innerText,
						videSales: tds[4].innerText,
						views: tds[5].innerText,
						videoCount: tds[6].innerText,
					}
					CrawlerUtils.crawlerState.goodsList.push(goods);
					return row;
				});
				sendKaoguStatus("productions");
				SocketServer.closeClientSocket();
			},
			callbackTimeout: function() {
				SocketServer.errorExit("tableRows page loading error");
			}
		});
	}
	else if (window.location.href.match(/^https:\/\/www.douyin.com\/video\//) && CrawlerUtils.crawlerState.status == "video") {
		CrawlerUtils.waitForCondition(0, window, 15000, 1000, {
			condition: function() {
				btns = [].slice.call(window.document.querySelectorAll("button.el-button.el-button--primary"));
				return btns[0].innerText == "登录/注册";
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
