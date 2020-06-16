#Opens file location in a new window with the XVIEWER program.
#-w makes xviewer use a single window, will replace an old instance of itself INSTEAD of just opening a new instance. (Should help reduce acidental/negligent RAM leaks.)
# & causes this to run as a separate process from this terminal/script, keeping the script from hanging until the newly opened process is killed.
xviewer -w testFiles/lobster.jpg &

#Stores the Process ID of the & generated process. in this case an xviewer window
viewerPID=$!

#Wait for 5 seconds. (Test purposes. Can choose to kill by other conditions later.)
sleep 5s

#Kill the Process of the xviewer window using the PID generated and stored into viewerPID at runtime.
kill $viewerPID
