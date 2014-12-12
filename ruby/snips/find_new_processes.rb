class FindNewProcesses
  require "socket"
  require 'pp'
  require 'sys/proctable'
  require 'time'
  require 'json'
  include Sys


  def initialize(regex, name)
    @name = name
    @hostname = Socket.gethostname
    json_file = "/tmp/#{@name}_pids.json"
    old_pids = read_json(json_file)
    matched = ProcTable.ps.select { |n| n.cmdline[regex] }
    current_pids = get_pids(matched)
    pp diff_pids(old_pids,current_pids)
    write_json(current_pids, json_file)
  end
  def diff_pids(old_pids, current_pids)
    current_pids - old_pids
  end

  def get_pids(matched)
    pids = Array.new
    matched.each do |proc|
      pids.push(proc.pid)
    end
    pids
  end

  def send_metric(metric_name)
    require 'socket'
    conn = TCPSocket.new 'carbon.hostedgraphite.com', 2003
    conn.puts "#{ENV["HOSTNAME"]}.restart 1.2\n"
    conn.close
  end

  def write_json(data, file)
    File.open(file, "w") do |f|
      f.write(data.to_json)
    end
  end

  def read_json(file)
    if File.exists?(file)
      JSON.parse(File.read(file))
    else
      return Array.new
    end
  end

end

 FindNewProcesses.new(/bash/, 'resin')
 #GrepMethods.new(/init/, 'resin-b')
