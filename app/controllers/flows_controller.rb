class FlowsController < ApplicationController
  def index
    @flows = Flow.all
  end

  def show
    @flow = Flow.find(params[:id])

    @flowJson = @flow.flowJson
  end

  def test

  end
end
