ActionController::Base.class_eval do
  # HELPERS
  helper_method :this_page?, :this_namespace?
  
  def this_page?(mask)
    mask = mask.split('#')

    c = mask[0]
    a = mask[1]

    flag = true

    flag = false if !c.blank? && c != controller_path
    flag = false if !a.blank? && a != action_name

    flag
  end

  def this_namespace?(namespace)
    current = controller_path.split('/').first

    return namespace == current
  end
  
  # FORM
  def styx_form_store_and_respond(entity, data=nil, &block)
    response.content_type = Mime::TEXT

    if entity.save
      styx_form_respond_success(data, entity, &block)
    else
      styx_form_respond_failure(entity.class.name, entity.errors.messages)
    end
  end
  
  def styx_form_respond_failure(entity, errors)
    response.content_type = Mime::TEXT
    
    errors = Hash[*errors.map {|x| [x, nil]}.flatten] if errors.is_a?(Array)
    render :text => {:entity => entity.to_s.underscore.gsub('/', '_'), :messages => errors}.to_json, :status => :unprocessable_entity
  end
  
  def styx_form_respond_success(data, entity=nil, &block)
    response.content_type = Mime::TEXT
    
    block.call(entity) if block_given?
    render :text => (data.is_a?(Proc) ? data.call(entity) : data)
  end
  
  # INITIALIZATION
  helper_method :styx_initialize, :styx_initialize_with
  before_filter { @styx_initialize_with = {} }

  def styx_initialize_with(data)
    @styx_initialize_with.merge! data
  end
  
  def styx_initialize()
    data   = @styx_initialize_with
    
    inits  = "#{controller_path.gsub('/', '_').camelize}Initializers"
    method = "#{action_name}"
    
    (render_to_string :partial => 'styx/initializer', :locals => {:inits => inits, :method => method, :data => data}).html_safe
  end
end