module Probability

function _01!(de)

    su = sum(de)

    map!(nu -> nu / su, de, de)

end

end
