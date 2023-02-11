function RCWA_structure_draw_xz(Epg_layer, structure_view_resolution, draw_unit, depth)
global Nx Tx layer_type Total_layer_num dc_profile Dimension;

if strcmp(draw_unit,'\mum');  dim_value = 1e-6;
elseif  strcmp(draw_unit,'nm'); dim_value = 1e-9;
end

if structure_view_resolution == 0
Nx_view = Nx;
else
Nx_view = Nx;
end

if (size(Epg_layer,3) == 0) || (strcmp(Dimension,'1D'))
    Nx_view = 200;
end


if strcmp(Dimension,'1D');  x_view = linspace(-dim_value,dim_value,Nx_view);                                 
else x_view = linspace(-Tx/2,Tx/2,Nx_view); end
z_view = linspace(0, sum(depth), Nx_view);

xz_map = zeros(length(z_view), length(x_view));
z_start = 1;
for tcnt = 1:1:Total_layer_num    
if layer_type(tcnt) == 0
dataset = dc_profile(tcnt)*ones(1,Nx_view);
else
cnt = layer_type(tcnt);
dataset = ifftshift(Nx_view*ifft(ifftshift(Epg_layer(:,:,cnt))));   
dataset = smooth(dataset,5)';
end

z_size = sum((z_view<depth(tcnt)));
xz_map(z_start:z_start+z_size-1,:) = repmat(dataset, [z_size 1]);

z_start = z_start + z_size;
end

figure(10);
imagesc(x_view/dim_value,z_view/dim_value, real(xz_map));
title(['Real({\it\epsilon})']); 
axis xy; caxis([-10 10]); colorbar;
xlabel(['x (', draw_unit, ')']); ylabel(['z (', draw_unit, ')']); 

map_i = repmat([1:-0.01:0]', [1 3]);
figure(11);
imagesc(x_view/dim_value,z_view/dim_value, -imag(xz_map));
title(['Imag({\it\epsilon})']); colormap(map_i); 
axis xy; colorbar; %caxis([-10 10]); 
xlabel(['x (', draw_unit, ')']); ylabel(['z (', draw_unit, ')']); 
end
