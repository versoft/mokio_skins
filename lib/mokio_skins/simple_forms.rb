require 'simple_form'

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a
  # complete input. You can remove any component from the
  # wrapper, change the order or even add your own to the
  # stack. The options given below are used to wrap the
  # whole input.

 # =========================================================================================== #

  config.wrappers :skin, :tag => 'div', :class => 'row-fluid', :error_class => 'error' do |b|
    b.use :html5
    b.use :maxlength
    b.use :placeholder
    b.use :readonly

    b.use :label_text, :wrap_with => { :tag => 'label', :class => 'form-label span2' }
    b.wrapper :tag => 'div', :class => 'span8' do |ba|
      ba.use :input
      ba.use :error, :wrap_with => { :tag => 'label', :class => 'error' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end
end