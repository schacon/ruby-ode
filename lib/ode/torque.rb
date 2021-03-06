#!/usr/bin/ruby
# 
# This file contains the ODE::Torque class, instances of which represent
# 3-dimensional angular force vectors that can be applied to an ODE::Body to
# rotate it in place.
# 
# == Synopsis
# 
#   
# 
# == Authors
# 
# * Michael Granger <ged@FaerieMUD.org>
# 
# Copyright (c) 2002, 2003 The FaerieMUD Consortium.
# 
# This work is licensed under the Creative Commons Attribution License. To
# view a copy of this license, visit
# http://creativecommons.org/licenses/by/1.0 or send a letter to Creative
# Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
# 
# == Version
#
#  $Id$
# 

require 'ode/vector'

module ODE

	### Instance of this class represent 3-dimensional angular force vectors
	### that can be applied to an ODE::Body to rotate it in place.
	class Torque < ODE::Vector

		### Create and return a new Torque object with the specified
		### coordinates.
		def initialize( x=0, y=0, z=0 )
			super( x, y, z )
		end

	end # class Torque

end # module ODE

