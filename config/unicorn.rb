# Configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
# working_directory "/home/seawolf/Code/Rails/OddityAvenue/" # available in 0.94.0+

# listen on a Unix domain socket
# we use a shorter backlog for quicker failover when busy
# listen "/tmp/oddity_avenue.sock", :backlog => 64

# nuke workers after 15 seconds instead of 60 seconds (the default)
timeout 15

# feel free to point this anywhere accessible on the filesystem
# pid "/tmp/unicorn_oddity_avenue.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
# stderr_path "/home/seawolf/Code/Rails/OddityAvenue/log/unicorn.stderr.log"
# stdout_path "/home/seawolf/Code/Rails/OddityAvenue/log/unicorn.stdout.log"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end