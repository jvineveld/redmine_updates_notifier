require 'rubygems'
require 'ostruct'

class UpdatesNotifierIssueChangeListener < Redmine::Hook::Listener
  def controller_issues_bulk_edit_after_save(context={})
    controller_issues_edit_after_save(context)
  end
  def controller_issues_edit_after_save(context={})
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:issue] and context[:journal]
        Thread.new {
          Rails.logger.error("### issue safe after, vanuit thread!")
          UpdatesNotifier.send_issue_update(User.current, context[:issue].id, context[:journal])
        }.run
      end
    end
  end
  def controller_issues_new_after_save(context={})
    Rails.logger.error("### issue new safe after, hook is run!")
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:issue]
        Thread.new {
          Rails.logger.error("### issue new safe after, vanuit thread!")
          UpdatesNotifier.send_issue_update(User.current, context[:issue].id)
        }.run
      end
    end
  end
  def controller_projects_new_after_save(context={})
    Rails.logger.error("### issue new project, hook is run!")
    if !Setting.plugin_redmine_updates_notifier[:ignore_api_changes] or !context[:params][:format] or 'xml' != context[:params][:format]
      if context[:project] and context[:journal]
        Thread.new {
          Rails.logger.error("### project new safe after, vanuit thread!")
          UpdatesNotifier.send_issue_update(User.current, context[:project].id, context[:journal])
        }.run
      end
    end
  end
end

