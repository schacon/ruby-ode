#
#	Install/distribution utility functions
#	$Id: utils.rb,v 1.1 2002/11/23 22:34:19 deveiant Exp $
#
#	Michael Granger <ged@FaerieMUD.org>
#	Copyright (c) 2001, 2002, The FaerieMUD Consortium.
#
#	This is free software. You may use, modify, and/or redistribute this
#	software under the terms of the Perl Artistic License. (See
#	http://language.perl.com/misc/Artistic.html)
#

require "readline"
include Readline

module UtilityFunctions

	# Set some ANSI escape code constants (Shamelessly stolen from Perl's
	# Term::ANSIColor by Russ Allbery <rra@stanford.edu> and Zenin <zenin@best.com>
	AnsiAttributes = {
		'clear'      => 0,
		'reset'      => 0,
		'bold'       => 1,
		'dark'       => 2,
		'underline'  => 4,
		'underscore' => 4,
		'blink'      => 5,
		'reverse'    => 7,
		'concealed'  => 8,

		'black'      => 30,   'on_black'   => 40, 
		'red'        => 31,   'on_red'     => 41, 
		'green'      => 32,   'on_green'   => 42, 
		'yellow'     => 33,   'on_yellow'  => 43, 
		'blue'       => 34,   'on_blue'    => 44, 
		'magenta'    => 35,   'on_magenta' => 45, 
		'cyan'       => 36,   'on_cyan'    => 46, 
		'white'      => 37,   'on_white'   => 47
	}
	def ansiCode( *attributes )
		attr = attributes.collect {|a| AnsiAttributes[a] ? AnsiAttributes[a] : nil}.compact.join(';')
		if attr.empty? 
			return ''
		else
			return "\e[%sm" % attr
		end
	end
	ErasePreviousLine = "\033[A\033[K"

	def testForLibrary( lib, nicename=nil )
		nicename ||= lib
		message( "Testing for the #{nicename} library..." )
		if $:.detect {|dir| File.exists?(File.join(dir,"#{lib}.rb")) || File.exists?(File.join(dir,"#{lib}.so"))}
			message( "found.\n" )
			return true
		else
			message( "not found.\n" )
			return false
		end
	end

	def testForRequiredLibrary( lib, nicename=nil, raaUrl=nil, downloadUrl=nil )
		nicename ||= lib
		unless testForLibrary( lib, nicename )
			msgs = [ "You are missing the #{nicename} library.\n" ]
			msgs << "RAA: #{raaUrl}\n" if raaUrl
			msgs << "Download: #{downloadUrl}\n" if downloadUrl
			message( msgs )
			exit 1
		end
		return true
	end

	def header( msg )
		msg.chomp!
		print ansiCode( 'bold', 'white', 'on_blue' ) + msg + ansiCode( 'reset' ) + "\n"
	end

	def message( msg )
		$stdout.print msg
		$stdout.flush
	end

	def replaceMessage( *msg )
		print ErasePreviousLine
		message( *msg )
	end

	def abort( msg )
		print ansiCode( 'bold', 'red' ) + "Aborted: " + msg.chomp + ansiCode( 'reset' ) + "\n\n"
		Kernel.exit!( 1 )
	end

	def prompt( promptString )
		promptString.chomp!
		return readline( ansiCode('bold', 'green') + "#{promptString}: " + ansiCode('reset') ).strip
	end

	def promptWithDefault( promptString, default )
		response = prompt( "%s [%s]" % [ promptString, default ] )
		if response.empty?
			return default
		else
			return response
		end
	end

	def findProgram( progname )
		ENV['PATH'].split(File::PATH_SEPARATOR).each {|d|
			file = File.join( d, progname )
			return file if File.executable?( file )
		}
		return nil
	end

	def extractNextVersionFromTags( file )
		message "Attempting to extract next release version from CVS tags for #{file}...\n"
		raise RuntimeError, "No such file '#{file}'" unless File.exists?( file )
		cvsPath = findProgram( 'cvs' ) or
			raise RuntimeError, "Cannot find the 'cvs' program. Aborting."

		output = %x{#{cvsPath} log #{file}}
		release = [ 0, 0 ]
		output.scan( /RELEASE_(\d+)_(\d+)/ ) {|match|
			if $1.to_i > release[0] || $2.to_i > release[1]
				release = [ $1.to_i, $2.to_i ]
				replaceMessage( "Found %d.%02d...\n" % release )
			end
		}

		if release[1] >= 99
			release[0] += 1
			release[1] = 1
		else
			release[1] += 1
		end

		return "%d.%02d" % release
	end
end