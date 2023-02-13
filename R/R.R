#Export tables
attach(mtcars)
#Data processing.
names = colnames(mtcars)

changend <- table(vs)
#Help documentation for subset command
#?subset
vs0 <- subset(mtcars, vs == 0)
vs1 <- subset(mtcars, vs == 1)
#Help documentation for t.test command
#?t.test
sink("results.txt")
#Summary stats and t test. 
mean(mpg)
sd(mpg)
testres <- t.test(vs0$mpg, vs1$mpg)
testres
sink()
#More data processing. 

#Then more results
sink("results.txt", append=TRUE)
#Creating Regression
lm(mpg~wt+disp+hp)
sink()





detach(mtcars)




#Export graph in basic terms
png("mpghp.png")
plot(mtcars$mpg, mtcars$hp)
dev.off()

#Test code export image
t = 1:100
x1 = 2*cos(2*pi*t*6/100) + 3*sin(2*pi*t*6/100)
x2 = 4*cos(2*pi*t*10/100) + 5*sin(2*pi*t*10/100)
x3 = 6*cos(2*pi*t*40/100) + 7*sin(2*pi*t*40/100)
x = x1 + x2 + x3 
png("figure_test.png")
par(mfrow=c(2,2))
plot.ts(x1, ylim=c(-10,10), main = expression(omega==6/100~~~A^2==13))
plot.ts(x2, ylim=c(-10,10), main = expression(omega==10/100~~~A^2==41)) 
plot.ts(x3, ylim=c(-10,10), main = expression(omega==40/100~~~A^2==85)) 
plot.ts(x, ylim=c(-16,16),main="sum") 
dev.off()


#Export graph using package
install.packages("ggplot2")
library(ggplot2)
ggplot(mtcars, aes(mpg, wt)) +
  geom_point(aes(colour=factor(cyl), size = qsec))

ggsave("mtcars.pdf")

ggsave("mtcars.pdf", width = 4, height = 4)
ggsave("mtcars.pdf", width = 20, height = 20, units = "cm")


#More advanced Tables with formatting. 


#Export the table using package stargazer. 
install.packages("stargazer")
library(stargazer)
stargazer(mtcars, type= "text", title= "Summary Statistics", out= "dat1.text")

m1 <- lm(mpg ~ hp, mtcars)
m2 <- lm(mpg~ drat, mtcars)
m3 <- lm(mpg ~ hp + drat, mtcars)

stargazer(m1, m2, m3,
          type = "html",
          out = "reg1.html",
          digits = 1,
          header = FALSE,
          title= "Regression Results",
          covariate.labels = c("Horsepower", "Rear axle ratio"))


#Another regression
linear.1 <- lm(rating ~ complaints + privileges + learning + raises + critical, data=attitude)
linear.2 <- lm(rating ~ complaints + privileges + learning, data=attitude) 

## create an indicator dependent variable, and run a probit model
attitude$highrating <- (attitude$rating > 70) 

logit.model <- glm(highrating ~ learning + critical + advance, data=attitude,
                   family = binomial(link = "logit"))

stargazer(linear.1, linear.2, logit.model,header=FALSE,
          title="My Nice Regression Table", type='html',digits=2, out = "reg2.html",
          dep.var.caption  = "A better caption",
          dep.var.labels.include = FALSE,
          model.names = FALSE,
          model.numbers = FALSE,
          column.labels   = c("Good", "Better","Best"),
          column.separate = c(1,1, 1)
)
