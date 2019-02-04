module ApplicationHelper
  def alerts
    alert = (flash[:alert] || flash[:error] || flash[:notice])

    if alert
      alert_generator alert
    end
  end

  def alert_generator msg
    js add_gritter(msg, title: "Pay attention!", time: 10000, class_name: "gritter" )
  end

  def datepicker_field(form, field)
    form.text_field(field, autocomplete:"off", data: { provide: "datepicker",
      'date-format': 'dd-mm-yyyy',
      'date-autoclose': 'true',
      'date-orientation': 'bottom auto',
          }).html_safe
end

end
