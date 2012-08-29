;*******************************************************************
; Function:  Wifi Robot Server Software
; Filename:  car_server.c
; Author:    Jon Bennett
; Website:   www.jbprojects.net/projects/wifirobot
; Credit:    Based on TCP Server Test Example
;            http://pont.net/socket/index.html
;*******************************************************************

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h> /* close */
#include <fcntl.h>
#include <string.h>

#include <termios.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/signal.h>
#include <sys/types.h>

#define SUCCESS 0
#define ERROR   1

#define DEBUG 1

#define END_LINE 0x0
#define SERVER_PORT 1500
#define MAX_MSG 100

/* function readline */
int read_line();

int main (int argc, char *argv[]) {
  int fd;
  int sd, newSd, cliLen;
  int result1;

  struct sockaddr_in cliAddr, servAddr;
  char line[MAX_MSG];

  	fd = open("/dev/tts/1", O_WRONLY);
	if (fd < 0) 
	{ 
		printf("Could not open port.\n"); 
	}

  result1 = write(fd, "jbpro", 5);

  /* create socket */
  sd = socket(AF_INET, SOCK_STREAM, 0);
   if(sd<0) {
    perror("cannot open socket ");
    return ERROR;
  }
  
  /* bind server port */
  servAddr.sin_family = AF_INET;
  servAddr.sin_addr.s_addr = htonl(INADDR_ANY);
  servAddr.sin_port = htons(SERVER_PORT);
  
  if(bind(sd, (struct sockaddr *) &servAddr, sizeof(servAddr))<0) {
    perror("cannot bind port ");
    return ERROR;
  }

  listen(sd,5);
  int count;
	count = 0;
  while(1) {
#if DEBUG
    printf("%s: waiting for data on port TCP %u\n",argv[0],SERVER_PORT);
#endif
    cliLen = sizeof(cliAddr);
    newSd = accept(sd, (struct sockaddr *) &cliAddr, &cliLen);
    if(newSd<0) {
      perror("cannot accept connection ");
      return ERROR;
    }
    
    /* init line */
    memset(line,0x0,MAX_MSG);
    unsigned char toWrite = 0;
    /* receive segments */
    while(read_line(newSd,line)!=ERROR) {
	count++;      
#if DEBUG
      printf("%d:  %s: received from %s:TCP%d : %s\n", count, argv[0], 
	     inet_ntoa(cliAddr.sin_addr),
	     ntohs(cliAddr.sin_port), line);
#endif
	char *buf="0";
        //toWrite = line[0];
	toWrite = line[0] - 1; 

	result1 = write(fd, &toWrite, 1); 

	if (result1 != 1)
	{
		printf("Error writing to serial port.\n");
	}

      /* init line */
      memset(line,0x0,MAX_MSG);
      
    } /* while(read_line) */
    
  } /* while (1) */

}


/* WARNING WARNING WARNING WARNING WARNING WARNING WARNING       */
/* this function is experimental.. I don't know yet if it works  */
/* correctly or not. Use Steven's readline() function to have    */
/* something robust.                                             */
/* WARNING WARNING WARNING WARNING WARNING WARNING WARNING       */

/* rcv_line is my function readline(). Data is read from the socket when */
/* needed, but not byte after bytes. All the received data is read.      */
/* This means only one call to recv(), instead of one call for           */
/* each received byte.                                                   */
/* You can set END_CHAR to whatever means endofline for you. (0x0A is \n)*/
/* read_lin returns the number of bytes returned in line_to_return       */
int read_line(int newSd, char *line_to_return) {
  
  static int rcv_ptr=0;
  static char rcv_msg[MAX_MSG];
  static int n;
  int offset;

  offset=0;

  while(1) {
    if(rcv_ptr==0) {
      /* read data from socket */
      memset(rcv_msg,0x0,MAX_MSG); /* init buffer */

      n = recv(newSd, rcv_msg, MAX_MSG, 0); /* wait for data */
      if (n<0) {
	perror(" cannot receive data ");
	return ERROR;
      } else if (n==0) {
	printf(" connection closed by client\n");
	close(newSd);
	return ERROR;
      }
    }
  
    /* if new data read on socket */
    /* OR */
    /* if another line is still in buffer */

    /* copy line into 'line_to_return' */
    while(*(rcv_msg+rcv_ptr)!=END_LINE && rcv_ptr<n) {
      memcpy(line_to_return+offset,rcv_msg+rcv_ptr,1);
      offset++;
      rcv_ptr++;
    }
    
    /* end of line + end of buffer => return line */
    if(rcv_ptr==n-1) { 
      /* set last byte to END_LINE */
      *(line_to_return+offset)=END_LINE;
      rcv_ptr=0;
      return ++offset;
    } 
    
    /* end of line but still some data in buffer => return line */
    if(rcv_ptr <n-1) {
      /* set last byte to END_LINE */
      *(line_to_return+offset)=END_LINE;
      rcv_ptr++;
      return ++offset;
    }

    /* end of buffer but line is not ended => */
    /*  wait for more data to arrive on socket */
    if(rcv_ptr == n) {
      rcv_ptr = 0;
    } 
    
  } /* while */
}
  
  

