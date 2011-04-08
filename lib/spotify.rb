# coding: utf-8
require 'ffi'
require 'spotify/version'

# FFI wrapper around libspotify.
# 
# See official documentation for more detailed documentation about
# functions and their behavior.
# 
# @see http://developer.spotify.com/en/libspotify/docs/
module Spotify
  extend FFI::Library
  ffi_lib ['libspotify', '/Library/Frameworks/libspotify.framework/libspotify']
  
  # libspotify API version
  # @return [Fixnum]
  API_VERSION = VERSION.split('.').first.to_i
  
  #
  # Error
  # 
  # @see http://developer.spotify.com/en/libspotify/docs/group__error.html
  enum :error, [:ok, :bad_api_version, :api_initialization_failed,
               :track_not_playable, :resource_not_loaded,
               :bad_application_key, :bad_username_or_password,
               :user_banned, :unable_to_contact_server,
               :client_too_old, :other_permanent, :bad_user_agent,
               :missing_callback, :invalid_indata,
               :index_out_of_range, :user_needs_premium,
               :other_transient, :is_loading, :no_stream_available,
               :permission_denied, :inbox_is_full, :no_cache,
               :no_such_user]
  
  attach_function :error_message, :sp_error_message, [ :error ], :string
  
  #
  # Audio
  # 
  # @see http://developer.spotify.com/en/libspotify/docs/group__session.html
  enum :sampletype, [:int16_native_endian]
  enum :bitrate, %w(160k 320k)
  
  # FFI::Struct for Audio Format.
  # 
  # @attr [:sampletype] sample_type
  # @attr [Fixnum] sample_rate
  # @attr [Fixnum] channels
  class AudioFormat < FFI::Struct
    layout :sample_type => :sampletype,
           :sample_rate => :int,
           :channels => :int
  end

  # FFI::Struct for Audio Buffer Stats.
  # 
  # @attr [Fixnum] samples
  # @attr [Fixnum] stutter
  class AudioBufferStats < FFI::Struct
    layout :samples => :int,
           :stutter => :int
  end
  
  #
  # Session
  # 
  # @see http://developer.spotify.com/en/libspotify/docs/group__session.html
  enum :connectionstate, [:logged_out, :logged_in, :disconnected, :undefined]

  attach_function :session_create, :sp_session_create, [ :pointer, :pointer ], :error
  attach_function :session_release, :sp_session_release, [ :pointer ], :void
  attach_function :session_login, :sp_session_login, [ :pointer, :string, :string ], :void
  attach_function :session_user, :sp_session_user, [ :pointer ], :pointer
  attach_function :session_logout, :sp_session_logout, [ :pointer ], :void
  attach_function :session_connectionstate, :sp_session_connectionstate, [ :pointer ], :connectionstate
  attach_function :session_userdata, :sp_session_userdata, [ :pointer ], :pointer
  attach_function :session_set_cache_size, :sp_session_set_cache_size, [ :pointer, :size_t ], :void
  attach_function :session_process_events, :sp_session_process_events, [ :pointer, :pointer ], :void
  attach_function :session_player_load, :sp_session_player_load, [ :pointer, :pointer ], :error
  attach_function :session_player_seek, :sp_session_player_seek, [ :pointer, :int ], :void
  attach_function :session_player_play, :sp_session_player_play, [ :pointer, :bool ], :void
  attach_function :session_player_unload, :sp_session_player_unload, [ :pointer ], :void
  attach_function :session_player_prefetch, :sp_session_player_prefetch, [ :pointer, :pointer ], :error
  attach_function :session_playlistcontainer, :sp_session_playlistcontainer, [ :pointer ], :pointer
  attach_function :session_inbox_create, :sp_session_inbox_create, [ :pointer ], :pointer
  attach_function :session_starred_create, :sp_session_starred_create, [ :pointer ], :pointer
  attach_function :session_starred_for_user_create, :sp_session_starred_for_user_create, [ :pointer, :string ], :pointer
  attach_function :session_publishedcontainer_for_user_create, :sp_session_publishedcontainer_for_user_create, [ :pointer, :string ], :pointer
  attach_function :session_preferred_bitrate, :sp_session_preferred_bitrate, [ :pointer, :bitrate ], :void
  attach_function :session_num_friends, :sp_session_num_friends, [ :pointer ], :int
  attach_function :session_friend, :sp_session_friend, [ :pointer, :int ], :pointer

  # FFI::Struct for {Hallon::Session} callbacks.
  # 
  # @attr [callback(:pointer, :error):void] logged_in
  # @attr [callback(:pointer):void] logged_out
  # @attr [callback(:pointer):void] metadata_updated
  # @attr [callback(:pointer, :error):void] connection_error
  # @attr [callback(:pointer, :string):void] message_to_user
  # @attr [callback(:pointer):void] notify_main_thread
  # @attr [callback(:pointer, :pointer, :pointer, :int):int] music_delivery
  # @attr [callback(:pointer):void] play_token_lost
  # @attr [callback(:pointer, :string):void] log_message
  # @attr [callback(:pointer):void] end_of_track
  # @attr [callback(:pointer, :error):void] streaming_error
  # @attr [callback(:pointer):void] userinfo_updated
  # @attr [callback(:pointer):void] start_playback
  # @attr [callback(:pointer):void] stop_playback
  # @attr [callback(:pointer, :pointer):void] get_audio_buffer_stats
  class SessionCallbacks < FFI::Struct
    layout :logged_in => callback([ :pointer, :error ], :void),
           :logged_out => callback([ :pointer ], :void),
           :metadata_updated => callback([ :pointer ], :void),
           :connection_error => callback([ :pointer, :error ], :void),
           :message_to_user => callback([ :pointer, :string ], :void),
           :notify_main_thread => callback([ :pointer ], :void),
           :music_delivery => callback([ :pointer, :pointer, :pointer, :int ], :int),
           :play_token_lost => callback([ :pointer ], :void),
           :log_message => callback([ :pointer, :string ], :void),
           :end_of_track => callback([ :pointer ], :void),
           :streaming_error => callback([ :pointer, :error ], :void),
           :userinfo_updated => callback([ :pointer ], :void),
           :start_playback => callback([ :pointer ], :void),
           :stop_playback => callback([ :pointer ], :void),
           :get_audio_buffer_stats => callback([ :pointer, :pointer ], :void)
  end

  # FFI::Struct for {Hallon::Session} configuration.
  # 
  # @attr [Fixnum] api_version
  # @attr [Pointer] cache_location
  # @attr [Pointer] settings_location
  # @attr [size_t] application_key_size
  # @attr [Pointer] user_agent
  # @attr [Pointer] callbacks
  # @attr [Pointer] userdata
  # @attr [Fixnum] dont_save_metadata_for_playlists
  # @attr [Fixnum] initially_unload_playlists
  class SessionConfig < FFI::Struct
    layout :api_version => :int,
           :cache_location => :pointer,
           :settings_location => :pointer,
           :application_key => :pointer,
           :application_key_size => :size_t,
           :user_agent => :pointer,
           :callbacks => :pointer,
           :userdata => :pointer,
           :compress_playlists => :int,
           :dont_save_metadata_for_playlists => :int,
           :initially_unload_playlists => :int    
  end
end