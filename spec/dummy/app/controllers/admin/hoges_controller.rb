module Admin
  class HogesController < ApplicationController
    include ::AdminResource
    actions :index
  end
end
