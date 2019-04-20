class StaticPageController < ApplicationController
  skip_before_action :authenticate_user!
  def home
  end
  def api_doc
  end
  def documentation
    table_names = User.connection.execute('show tables').to_a.flatten
    @table_descs = []
    table_names.each do |table_name|
      desc = User.connection.execute("desc #{table_name};").to_a
      @table_descs << {table_name: table_name, desc: desc}
    end
  end
end
