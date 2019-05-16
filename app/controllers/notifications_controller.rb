# frozen_string_literal: true

# Used to show and update status of notifications

class NotificationsController < ApplicationController
  # Show all notifications for current user
  def index
    @notifications = PublicActivity::Activity.where(recipient_id:
                                                    current_user.id)
  end

  # Set read status of every notification to true
  # Called using JS Ajax on #index visit
  def read_all
    PublicActivity::Activity.where(recipient_id: current_user.id)
                            .update_all(read: true)
    head :ok
  end
end
