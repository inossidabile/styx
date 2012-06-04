@Styx.Forms =
  validate: (element, success_action=false, error_action=false, substitutions={}) ->    
    $(element).live 'ajax:success', (event, result, status, xhr) ->
      $(element).find('.field_with_errors').children().unwrap()
    
      unless success_action
        Styx.URL.go xhr.responseText, true
      else
        success_action.call(this, xhr.responseText)

    $(element).live 'ajax:error', (evt, xhr, status, error) ->
      $(element).find('.field_with_errors').children().unwrap()
      error_action.call(this) if error_action
  
      errors = jQuery.parseJSON xhr.responseText
  
      for field, notifications of errors.messages
        field = substitutions[field] if substitutions[field]?
        input = $(element).find("##{errors.entity}_#{field}")

        # Support for Chosen jQuery plugin
        if input.is('.chzn-done')
          input = $(element).find("##{errors.entity}_#{field}_chzn")

        input.wrap("<div class='field_with_errors' />")