function win=my_gausswin(win_size,winSD)
pdf_vec=[-(win_size-1)/2:(win_size-1)/2];
win=normpdf(pdf_vec,0,winSD);
win=win/sum(win);
