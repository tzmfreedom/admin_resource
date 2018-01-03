module Admin
  class DummyController < ApplicationController
    include AdminResource::Base.new(:index, :show, :new, :create, :edit, :update, :destroy)

    def index; end
  end
end
