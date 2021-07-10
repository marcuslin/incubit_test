module ApplicationHelper
  def flash_messages
    messages = flash[:notice] || flash[:error]
    flash_messageg_classes = { notice: 'success', error: 'danger' }

    if flash.any?
      tag.div(class: "alert alert-#{flash_messageg_classes[flash.keys.first.to_sym]}") do
        if messages.is_a?(String)
          tag.li(messages)
        else
          messages.collect { |message| concat(tag.li(message)) }
        end
      end
    end
  end
end
