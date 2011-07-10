require "spec_helper"

describe MenusController do
  
  describe '#new' do
    
    it "should assign a new menu to @menu" do
      get 'new'
      assigns(:menu).should be_a_new(Menu)
    end
    
  end
  
end