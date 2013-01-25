module Mortar
  class API

    def do_local_illustrate(pigscript, pigscript_alias)
      cmd = "/usr/local/pig-toolbelt/bin/illustrate.sh #{pigscript} #{pigscript_alias}"

      pipe_cmd_in, pipe_cmd_out = IO.pipe
      cmd_pid = Process.spawn(
        cmd, 
        :out => pipe_cmd_out, 
        :err => pipe_cmd_out)

      @exitstatus = :not_done
      Thread.new do
        Process.wait(cmd_pid); 
        @exitstatus = $?.exitstatus
      end

      pipe_cmd_out.close
      out = pipe_cmd_in.read;
      sleep(0.1) while @exitstatus == :not_done
      puts "#{out}"
      puts "Exit status: #{@exitstatus}"
    end
  end
end
