# 
# healthCheck.py - v0.1
# - Runs casperJs and Jasmine-node and sends email
# Author - Vasanth Selvaraj
#
import fileinput
import xml.dom.minidom
import subprocess
from subprocess import call

# convert xml to html
def htmlConv():
	call(["jasmine-node","htmlconv.spec.js"])

# perl program to send email of health check report
def sendEmail():
	call(["perl","mail.pl","HealthReport"])

# execute the testcases using casperjs
def executeCasper(appName,logFile,count):
	mainProcess = subprocess.Popen(["casperjs","--ignore-ssl-errors=true","test",appName,logFile], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	communicateRes = mainProcess.communicate() 
	for test in communicateRes:
		print test
	stdOutValue, stdErrValue = communicateRes
	my_output_list = stdOutValue.split(" ")
	# after the split we have a list of string in my_output_list 
	for word in my_output_list :
		if ( word == "failed" and count < 4 ):
    		   print "*Executing failed testcase iterating -> " + `count`  + '->' + appName
		   count +=1
		   executeCasper(appName,logFile,count)

# Trim xml to send email	
def xmlConv(xmlname):
	xmldoc = xml.dom.minidom.parse(xmlname)
	doc_root = xmldoc.documentElement
	for node in xmldoc.getElementsByTagName('testsuite'):
		fullXML.write(node.toxml())
	
	#pretty_xml_as_string = dom.toprettyxml()
	#print pretty_xml_as_string

# main program - reads urlDetails.txt (loop for all the environment)
def main():
	global xmldoc, fullXML, count
	count = 0
	with open('urlDetails.txt') as fp, open('log.xml','w') as fullXML:
		fullXML.write('<?xml version="1.0" encoding="UTF-8"?><testsuites time="dummy">')
        	for line in fp:
               # 	print line
	                fields = line.split(',')
			print '----------------------------------------'
        	        print '*Executing ->' + fields[4] + '->' + fields[1]
                	replacements = {'<LogicalName>':fields[0],'<URL>':fields[1],'<USERNAME>':fields[2],'<PASSWORD>':fields[3],'<application>':fields[4],'<LookForValue>':fields[5].strip()}
	                with open('template.js') as infile, open('test/' + fields[0] + '.js','w') as outfile:
        	                for line in infile:
                	                for src, target in replacements.iteritems():
                        	                line = line.replace(src,target)
                                	outfile.write(line)
			executeCasper("test/" + fields[0] + ".js","--xunit=" + fields[4] + "/" + fields[0] +".xml",count)
        	        xmlConv(fields[4] + "/" + fields[0] +".xml")
        	        infile.close()
	                outfile.close()
        	fp.close()
		fullXML.write('</testsuites>')
		fullXML.close()
	htmlConv()
	sendEmail()
main()
