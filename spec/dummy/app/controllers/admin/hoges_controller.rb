module Admin
  class HogesController < ApplicationController
    include ::AdminResource
    actions :index

    list_fields :name, :in, :bl
  end
end
