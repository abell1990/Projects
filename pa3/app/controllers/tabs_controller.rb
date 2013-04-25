class TabsController < ApplicationController
  
  def show2
  	@tabs1 = [{:label => "Inventory", :url => "inventories.html"}, 
  			  {:label => "Order Information", :url => "orders.html"}, 
  		      {:label => "Accounts", :url => "accounts.html"}, 
  		      {:label => "Shippers", :url => "shippers.html"}, 
  		      {:label => "Suppliers", :url => "suppliers.html"}];
  	@selectedTab1 = "Accounts";

  	@tabs2 = [{:label => "The Beatles", :url => "beatles.html"}, 
  			  {:label => "The Doors", :url => "doors.html"}, 
  		      {:label => "The Darkness", :url => "darkness.html"}, 
  		      {:label => "Nirvana", :url => "nirvana.html"}, 
  		      {:label => "BB King", :url => "bbking.html"}, 
  		      {:label => "Radiohead", :url => "radiohead.html"}, 
  		      {:label => "Compay Segundo", :url => "compay.html"}];
  	@selectedTab2 = "Radiohead";
  end

end