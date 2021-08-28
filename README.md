# WebRelay-GeekTechesNC1601
Control GeekTechesNC1601 written in bash.
The IP address and "port" (If you want to call it that) can be set in the top of the file.

./relay.sh ss     - Will show the current relay state

The following is an example on how to turn a relay on and off. This can be changed to, for example 5o, 6o, 14o to turn these relays on or 5f, 6f, 14f to turn these relays off.  

./relay.sh 1o     - Will turn relay 1 on<br>
./relay.sh 1f     - Will turn relay 1 off
<br>
<br>
Replace the number with an "a" to change all relays. (This needs work.).
./relay.sh 1o - to turn all relays on
./relay.sh 1f - to turn all relays off
<br>
<br>
./relay.sh c will enter comple mode (Not great tbh)
<br>
Sub commands example:<br>
s1 - sleep 1 second<br>
s5m - sleep 5 minuites<br>
s2h - sleep 2 hours<br>
then all other commands eg. 1o, 5f ect<br><br>

For loop in compile mode:<br>
f10 will loop 10 times<br>
ef: end the for loop<br>


