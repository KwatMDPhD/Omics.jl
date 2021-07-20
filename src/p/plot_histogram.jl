using Plotly: Layout, plot

function plot_histogram()

    trace_ = []

    layout = Layout()

    return plot(trace_, layout)

end

export plot_histogram

#def plot_histogram(
#    vector_,
#    label__,
#    name_,
#    histnorm=None,
#    bin_size=None,
#    plot_rug=None,
#    colorscale=CATEGORICAL_COLORSCALE,
#    layout=None,
#    file_path=None,
#):
#
#    if plot_rug is None:
#
#        plot_rug = all(vector.size <= 1e3 for vector in vector_)
#
#    data_n = len(name_)
#
#    if plot_rug:
#
#        height = 0.04
#
#        yaxis_max = data_n * height
#
#        yaxis2_min = yaxis_max + height
#
#    else:
#
#        yaxis_max = 0
#
#        yaxis2_min = 0
#
#    if histnorm is None:
#
#        yaxis2_title_text = "N"
#
#    else:
#
#        yaxis2_title_text = histnorm.title()
#
#    base = {
#        "xaxis": {"anchor": "y"},
#        "yaxis2": {"domain": (yaxis2_min, 1), "title": {"text": yaxis2_title_text}},
#        "yaxis": {
#            "domain": (0, yaxis_max),
#            "zeroline": False,
#            "dtick": 1,
#            "showticklabels": False,
#        },
#    }
#
#    if layout is None:
#
#        layout = base
#
#    else:
#
#        layout = merge(base, layout)
#
#    data = []
#
#    for (
#        index,
#        (vector, label_, name),
#    ) in enumerate(zip(vector_, label__, name_)):
#
#        color = get_color(colorscale, index / max(1, (data_n - 1)))
#
#        base = {
#            "legendgroup": index,
#            "name": name,
#            "x": vector,
#        }
#
#        data.append(
#            {
#                "yaxis": "y2",
#                "type": "histogram",
#                "histnorm": histnorm,
#                "xbins": {"size": bin_size},
#                "marker": {"color": color},
#                **base,
#            }
#        )
#
#        if plot_rug:
#
#            data.append(
#                {
#                    "showlegend": False,
#                    "y": (index,) * vector.size,
#                    "text": label_,
#                    "mode": "markers",
#                    "marker": {"symbol": "line-ns-open", "color": color},
#                    "hoverinfo": "x+text",
#                    **base,
#                }
#            )
#
#    plot_plotly({"data": data, "layout": layout}, file_path=file_path)
#
#
