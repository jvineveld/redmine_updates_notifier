require 'rubygems'
require 'ostruct'

class UpdatesNotifierIssueChangeListener < Redmine::Hook::Listener
  def controller_issues_bulk_edit_after_save(context={})
    controller_issues_edit_after_save(context)
  end
  def controller_issues_edit_after_save(context={})
    Rails.logger.error("### issue edit safe after, hook is run!")
    Rails.logger.error(context[:params][:format])
    Rails.logger.error(context[:issue])
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:issue] and context[:journal]
        currentUser = User.current
        Thread.new(currentUser, context) { |currentUser, context|
          UpdatesNotifier.send_issue_update(currentUser, context[:issue].id, context[:journal])
        }.run
      end
    end
  end
  def controller_issues_new_after_save(context={})
    Rails.logger.error("### issue new safe after, hook is run!")
    Rails.logger.error(context[:params][:format])
    Rails.logger.error(context[:issue])
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:issue]
       Rails.logger.error("### issue new safe after, inside statement!")
        currentUser = User.current
        Thread.new(currentUser, context) { |currentUser, context|
        Rails.logger.error("### issue new safe after, inside thread!")
          UpdatesNotifier.send_issue_update(currentUser, context[:issue].id)
        }.run
      end
    end
  end
  def controller_projects_new_after_save(context={})
    Rails.logger.error("### issue new project, hook is run!")
    Rails.logger.error(context[:params][:format])
    Rails.logger.error(context[:issue])
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:project] and context[:journal]
        currentUser = User.current
        Thread.new(currentUser, context) { |currentUser, context|
        Rails.logger.error("### project new safe after, inside thread!")
          UpdatesNotifier.send_issue_update(currentUser, context[:project].id)
        }.run
      end
    end
  end
end

