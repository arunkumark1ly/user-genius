require 'liquid'
require 'action_view'

module LiquidTemplateHandler
  def self.call(template, source)
    # Extract the controller from the source if available
    controller = source.respond_to?(:controller) ? source.controller : nil

    # Prepare the assigns (variables) for the Liquid template
    assigns = controller ? controller.view_assigns.stringify_keys : {}

    # Add @users to assigns if it exists
    users = assigns['users']  # Assuming 'users' is directly available in assigns
    assigns['users'] = users if users

    # Optionally, include the form authenticity token for forms
    if controller && controller.respond_to?(:protect_against_forgery?) && controller.protect_against_forgery?
      assigns['authenticity_token'] = controller.form_authenticity_token
    end

    Rails.logger.debug "Assigns: #{assigns}"
    Rails.logger.debug "Template: #{template.source}"
    # Parse and render the Liquid template with the assigns
    Liquid::Template.parse(template.source).render(assigns)
  end
end

ActionView::Template.register_template_handler(:liquid, LiquidTemplateHandler)
