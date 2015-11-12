package main

import (
	"encoding/xml"
	"fmt"
	"os"
	"strconv"
	"text/template"
)

type Member struct {
	Field	string `xml:"Field,attr"`
	Type 	string `xml:"Type,attr"`
	Len     string `xml:"Len,attr"`
}

type Struct struct {
	Name     string    `xml:"name,attr"`
	Members  []Member  `xml:"field"`
}

type Database struct {
	XMLName xml.Name `xml:"database"`
	Structs []Struct `xml:"table_structure"`
}

type Result struct {
	XMLName xml.Name `xml:"mysqldump"`
	Databases Database `xml:"database"`
}

var result = Result{}

func main() {
	// db
	if !parse("ese2db.xml") {
		return
	}
	
	//manual copy to game-common directory
	if !output("DB_STRUCT.tpl", "DB_STRUCT.h") {
		return
	}
	//manual copy to game-common directory
	if !output("_DB_PACKET_STRUCT.tpl", "_DB_PACKET_STRUCT.h") {
		return
	}

//	// manual copy to game-common directory
	if !output("DB_ACTIVE_RECORD_MSG.tpl", "DB_ACTIVE_RECORD_MSG.h") {
		return
	}
	
	// manual copy to dataserver directory
	if !output("ACTIVE_RECORD_LOGIC.tpl", "ACTIVE_RECORD_LOGIC.cpp") {
		return
	}
	
	// 
	if !output("DB_NET_MSG_RET.tpl", "DB_NET_MSG_RET.h") {
		return
	}
	
//	if !output("DB_VAR_NET_MSG.tpl", "DB_VAR_NET_MSG.h") {
//		return
//	}
	
	
	fmt.Println("OK")
}

func parse(name string) bool {
	file, err := os.Open(name)
	if err != nil {
		fmt.Println(err)
		return false
	}

	var buffer [1024 * 1024]byte
	n, rerr := file.Read(buffer[0:])
	if rerr != nil {
		fmt.Println(rerr)
		return false
	}

	err = xml.Unmarshal(buffer[0:n], &result)
	if err != nil {
		fmt.Println(err)
		return false
	}

	fmt.Println(result);
	return true
}

func genlist(n string) []string {
	num, _ := strconv.Atoi(n)
	ret := make([]string, num)
	for i := 0; i < num; i++ {
		ret[i] = strconv.Itoa(i)
	}
	return ret
}

func output(src string, des string) bool {

	file, err := os.Create(des)
	if err != nil {
		fmt.Println(err)
		return false
	}

	t := template.New("text")
	if err != nil {
		fmt.Println(err)
		return false
	}

	t = t.Funcs(template.FuncMap{"genlist": genlist})

	srcfile, err := os.Open(src)
	if err != nil {
		fmt.Println(err)
		return false
	}

	var buffer [1024 * 1024]byte
	n, rerr := srcfile.Read(buffer[0:])
	if rerr != nil {
		fmt.Println(rerr)
		return false
	}

	t, err = t.Parse(string(buffer[0:n]))
	if err != nil {
		fmt.Println(err)
		return false
	}

	err = t.Execute(file, result.Databases.Structs)
	if err != nil {
		fmt.Println(err)
		return false
	}

	return true
}
