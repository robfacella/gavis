#Opens file location in a new window with the XVIEWER program.
xviewer -w testFiles/lobster.jpg &
#Stores the Process ID of the xviewer window
viewerPID=$!

#Wait for 5 seconds. (Test purposes. Can choose to kill by other conditions later.)
sleep 5s
#Kill the Process of the xviewer window using the PID generated and stored into viewerPID at runtime.
kill $viewerPID
