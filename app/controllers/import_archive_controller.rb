class ImportArchiveController < ApplicationController
  def list
    @files = Dir.glob('imports/**/*')
  end
end
