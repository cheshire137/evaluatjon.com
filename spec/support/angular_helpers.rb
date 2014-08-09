module AngularHelpers
  def fill_ng ng_model, options={}
    find('input[ng-model="' + ng_model + '"]').set options[:with]
  end
end
