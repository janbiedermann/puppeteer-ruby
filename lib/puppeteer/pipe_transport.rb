class Puppeteer::PipeTransport
  def initialize(writable_stream, readable_stream)
    @out = writable_stream
    @in = readable_stream
    @reader = Thread.new do
      @on_message&.call(@in.read.chop!)
    end
  end

  def send_text(message)
    @out.write(message)
    @out.write("\0")
  end

  def close
    @out.close
    @in.close
  rescue
    #
  end

  def on_close(&block)
    @on_close = block
  end

  def on_message(&block)
    @on_message = block
  end
end