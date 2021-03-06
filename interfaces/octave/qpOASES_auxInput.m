%qpOASES -- An Implementation of the Online Active Set Strategy.
%Copyright (C) 2007-2014 by Hans Joachim Ferreau, Andreas Potschka,
%Christian Kirches et al. All rights reserved.
%
%qpOASES is distributed under the terms of the
%GNU Lesser General Public License 2.1 in the hope that it will be
%useful, but WITHOUT ANY WARRANTY; without even the implied warranty
%of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%See the GNU Lesser General Public License for more details.
%
%---------------------------------------------------------------------------------
%
%Returns a struct containing all possible auxiliary inputs to be passed 
%to qpOASES.
%
%Call
%    auxInput = qpOASES_auxInput();
%to obtain a struct with all auxiliary inputs empty.
%
%Call
%    options = qpOASES_auxInput( 'input1',value1,'input2',value2,... )
%to obtain a struct with 'input1' set to value1 etc. and all remaining
%auxiliary inputs empty.
%
%Call
%    options = qpOASES_auxInput( oldInputs,'input1',value1,... )
%to obtain a copy of the options struct oldInputs but with 'input1' set to 
%value1 etc.
%
%
%qpOASES features the following auxiliary inputs:
%  x0                   -  Initial guess for optimal primal solution.
%  guessedWorkingSet    -  Initial guess for working set at optimal
%                          solution. The first nV elements correspond 
%                          to the bounds, the last nC elements to the 
%                          constraints.
%                          The working set needs to be encoded as follows:
%                          1: bound/constraint at its upper bound
%                          0: bound/constraint not at any bound
%                         -1: bound/constraint at its lower bound
%
%
%See also QPOASES, QPOASES_SEQUENCE, QPOASES_OPTIONS
%
%
%For additional information see the qpOASES User's Manual or
%visit http://www.qpOASES.org/.
%
%Please send remarks and questions to support@qpOASES.org!
function [ auxInput ] = qpOASES_auxInput( varargin )

	firstIsStruct = 0;

	if ( nargin == 0 ) 
		auxInput = qpOASES_emptyAuxInput();
	else
		if ( isstruct( varargin{1} ) )
			if ( mod( nargin,2 ) ~= 1 )
				error('ERROR (qpOASES_auxInput): Auxiliary inputs must be specified in pairs!');
			end
			auxInput = varargin{1};
			firstIsStruct = 1;
        else
            if ( mod( nargin,2 ) ~= 0 )
				error('ERROR (qpOASES_auxInput): Auxiliary inputs must be specified in pairs!');
            end
            auxInput = qpOASES_emptyAuxInput();
		end
	end

	% set options to user-defined values  
	for i=(1+firstIsStruct):2:nargin

		argName  = varargin{i};
		argValue = varargin{i+1};

        if ( ( isempty( argName ) ) || ( ~ischar( argName ) ) )
			error('ERROR (qpOASES_auxInput): Argmument no. %d has to be a non-empty string!',i );
        end
			
        if ( ( ischar(argValue) ) || ( ~isnumeric( argValue ) ) )
			error('ERROR (qpOASES_auxInput): Argmument no. %d has to be a numerical constant!',i+1 );
        end

        if ( ~isfield( auxInput,argName ) )
			error('ERROR (qpOASES_auxInput): Argmument no. %d is not a valid auxiliary input!',i );
        end

		eval( ['auxInput.',argName,' = argValue;'] );

	end

end


function [ auxInput ] = qpOASES_emptyAuxInput( )

	% setup auxiliary input struct with all entries empty
	auxInput = struct(	'x0',                 [], ...
						'guessedWorkingSet',  []  ...
                        );

end
