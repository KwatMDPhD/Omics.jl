using Plotly: Layout, Style, use_style! as Plotlyuse_style!

function use_style!()::Style

    return Plotlyuse_style!(
        Style(
            layout = Layout(
                autosize = false,
                template = "plotly_white",
                hovermode = "closest",
                xaxis_automargin = true,
                yaxis_automargin = true,
            ),
        ),
    )

end

export use_style!
