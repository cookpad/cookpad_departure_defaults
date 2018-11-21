require "cookpad_departure_defaults/version"
require "departure"

module CookpadDepartureDefaults

  def self.pt_plugin_path
    File.join(__dir__,
              "cookpad_departure_defaults",
              "pt-online-schema-change-plugin.pl")
  end

  def self.global_percona_args
    %W( --charset=utf8mb4
        --recurse=0
        --recursion-method=none
        --max-load\ Threads_running=100
        --critical-load\ Threads_running=120
        --chunk-time=1.0
        --plugin\ #{pt_plugin_path}
        --sleep\ 0.1
        --alter-foreign-keys-method\ rebuild_constraints).join(" ")
  end

  Departure.configure {}
  Departure.configuration.global_percona_args = global_percona_args

end
