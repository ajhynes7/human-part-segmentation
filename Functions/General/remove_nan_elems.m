function varargout = remove_nan_elems(varargin)
% Removes elements with nan values from multiple inputs.
% If element is nan in any of the inputs, it is removed from all inputs.
% 
% Inputs
%
%	varargin : cell
%       Variable arguments in
%       All inputs must have same dimensions
%
% Outputs
%
%   varargout : cell
%       Variable arguments out
%       Inputs with nan elements removed

varargout = varargin;

% Find index of nan values in all inputs
nan_idx = false(size(varargin{1}));
for i = 1:nargin
    nan_idx = nan_idx | isnan(varargin{i});
end

% Remove nans
for i = 1:nargin
    varargout{i}(nan_idx) = [];
end

end

