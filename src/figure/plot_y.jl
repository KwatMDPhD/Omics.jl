function plot_y(fu, y_; ke_ar...)

    fu(y_, [1:length(y) for y in y_]; ke_ar...)

end
