function selected_color = find_RGB(lambda_RGB,lambda)

[dummy selected_color] =min(abs(lambda_RGB-lambda));

end