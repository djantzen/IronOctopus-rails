require 'pp'

module LogUtils

  def wtf?(args)
    puts "*********************************!!!wtf?!!!************************************"
    puts Time.now
    puts caller(1).first
    puts pp(args)
    puts "*******************************************************************************"
  end

end
