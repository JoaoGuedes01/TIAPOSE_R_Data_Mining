data <- read.csv(file = '../data/store.csv', sep = ';')



# ver que obserca��es correspondem aos valores de 7961 9371 9163 8300 8270 15735 7719 11110
data[data$all %in% c(7961, 9371, 9163, 8300, 8270, 15735, 7719, 11110),]
print('ola')


# conclusoes:
# dia 03-08-2013 sabado
# dia 04-08-2013 domingo
# dia 15-08-2013 foi feriado secalhar foi por causa dessa merda
# dia 27-08-2013 sabado
# dia 03-10-2013 quinta
# dia 06-10-2013 foi domingo?
# dia 16-11-2013 foi sabado
# dia 14-12-2013 preparar para o natal prendas e o crl?