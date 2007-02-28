## Copyright (C) 2007 Aida Alvera-Azcárate
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

## -*- texinfo -*-
## @deftypefn {Loadable Function} {[@var{fi},@var{vari}] = } optiminterp(@var{x},@var{y},@var{z},@var{f},@var{var},@var{lenx},@var{leny},@var{lenz},@var{m},@var{xi},@var{yi},@var{zi})
## Performs a local 4D-optimal interpolation (objective analysis).
##
## Every elements in @var{f} corresponds to a data point (observation)
## at location  @var{x}, @var{y}, @var{z}, @var{t} with the error variance var
##
## @var{lenx},@var{leny},@var{lenz} and @var{lent} are correlation length in x-,y-,z-direction and time,
## respectively. 
## @var{m} represents the number of influential points.
##
## @var{xi},@var{yi},@var{zi} and @var{ti} are the data points where the field is
## interpolated. @var{fi} is the interpolated field and @var{vari} is 
## its error variance.
##
##
## The background field of the optimal interpolation is zero.
## For a different background field, the background field
## must be subtracted from the observation, the difference 
## is mapped by OI onto the background grid and finally the
## background is added back to the interpolated field.
##
## The error variance of the background field is assumed to 
## have a error variance of one. 
## @end deftypefn

## Copyright (C) 2007, Aida Alvera-Azcárate
## Author: Aida Alvera-Azcárate <aalvera@marine.usf.edu>, Alexander Barth <abarth@marine.usf.edu>

function [fi,vari] = optiminterp4(x,y,z,t,f,var,lenx,leny,lenz,lent,m,xi,yi,zi,ti)

if (isscalar(var))
  var = var*ones(size(x));
end

if isvector(f) & size(f,1) == 1
   f = f';
end

on = numel(x);
nf = size(f,5);

if (on*nf == numel(f) & on ~= numel(y) & on ~= numel(z) & ...
    on ~= numel(t)  & on ~= numel(var))
  error('optiminterp4: x,y,z,t,f,var must have the same number of elements');
end

if (numel(xi) ~= numel(yi) & numel(xi) ~= numel(zi) & numel(xi) ~= numel(ti))
  error('optiminterp4: xi, yi, zi and ti must have the same number of elements');
end

gx(:,1) = xi(:); 
gx(:,2) = yi(:); 
gx(:,3) = zi(:); 
gx(:,4) = ti(:); 

ox(:,1) = x(:);
ox(:,2) = y(:);
ox(:,3) = z(:);
ox(:,4) = t(:);

f=reshape(f,[on nf]);

[fi,vari] = optiminterp(ox,f,var,[lenx leny lenz lent],m,gx);

fi = reshape(fi,[size(xi) nf]);
vari = reshape(vari,size(xi));
