//
//  Count.swift
//  transmedik
//
//  Created by Idham Kurniawan on 09/07/21.
//


import Foundation
import UIKit
class Count{
    func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60

        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
    
    
    func getday(waktu : String)->String{

        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let hidet = waktu.replacingOccurrences(of: "T", with: " ")
        let zona = hidet.replacingOccurrences(of: ".000000Z", with: "")
        let dates: Date = myDateFormatter.date(from: String(zona.dropLast(3)))!
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: dates)
        
        var bulanstring = ""
        let bulanformat = DateFormatter()
        bulanformat.dateFormat = "MM"
        let bulan = bulanformat.string(from: dates)
        
        let tahunformat = DateFormatter()
        tahunformat.dateFormat = "yyyy"
        let taun = tahunformat.string(from: dates)
        
        let tglformat = DateFormatter()
        tglformat.dateFormat = "dd"
        let tgl = tglformat.string(from: dates)
        
        print( "ini bulan \(bulan)")
        
        switch Int(bulan) {
        case 1:
            bulanstring = "Jan"
        case 2:
            bulanstring = "Feb"
        case 3:
            bulanstring = "Mar"
        case 4:
            bulanstring = "Apr"
        case 5:
            bulanstring = "Mei"
        case 6:
            bulanstring = "Jun"
        case 7:
            bulanstring = "Jul"
        case 8:
            bulanstring = "Agu"
        case 9:
            bulanstring = "Sep"
        case 10:
            bulanstring = "Okt"
        case 11:
            bulanstring = "Nov"
        case 12:
            bulanstring = "Des"
            
        default:
            print("Error")
        }
        
        let tanggals = "\(tgl)-\(bulanstring)-\(taun)"
        switch dayInWeek {
        case "Monday":
          return "Sen, \(tanggals)"
        case "Tuesday":
          return "Sel, \(tanggals)"
        case "Wednesday":
          return "Rab, \(tanggals)"
        case "Thursday":
          return "Kam, \(tanggals)"
        case "Friday":
          return "Jum, \(tanggals)"
        case "Saturday":
          return "Sab, \(tanggals)"
        case "Sunday":
          return "Min, \(tanggals)"
        default:
            return "\(dayInWeek), \(tanggals)"
        }
        
       
    }
    
    func hitunghari(waktu :String) -> String{
          
          let myDateFormatter = DateFormatter()
          myDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
          
          let hidet = waktu.replacingOccurrences(of: "T", with: " ")
          let zona = hidet.replacingOccurrences(of: ".000000Z", with: "")
        print("ini zona count")
        print(zona)
          let oldDate: Date = myDateFormatter.date(from: String(zona.dropLast(3)))!
          let minute = minutesBetweenDates(oldDate, Date())
          if minute > 60.0 && minute < 1440.0{
              
              let menit = (minute/60.0).rounded(.up)
              return "\(Int(menit)) Jam"
              
          }else if minute > 1440.0 {
              
              let format = DateFormatter()
              format.dateFormat = "yyyy-MM-dd"
              //            let waktu = format.string(from: String(zona.dropLast(9)))
              return"\(calculateAge(dob: String(zona.dropLast(9)), format: "yyyy-MM-dd").day) Hari"
              
          }else{
              let menit = minute.rounded(.up)
              return "\(Int(menit)) menit"
              
          }
      }
    
    
    func calculateAge(dob : String, format:String = "yyyy-MM-dd") -> (year :Int, month : Int, day : Int){
           let df = DateFormatter()
           df.dateFormat = format
           let date = df.date(from: dob)
           guard let val = date else{
               return (0, 0, 0)
           }
           var years = 0
           var months = 0
           var days = 0
           
           let cal = Calendar.current
           years = cal.component(.year, from: Date()) -  cal.component(.year, from: val)
           
           let currMonth = cal.component(.month, from: Date())
           let birthMonth = cal.component(.month, from: val)
           
           //get difference between current month and birthMonth
           months = currMonth - birthMonth
           //if month difference is in negative then reduce years by one and calculate the number of months.
           if months < 0
           {
               years = years - 1
               months = 12 - birthMonth + currMonth
               if cal.component(.day, from: Date()) < cal.component(.day, from: val){
                   months = months - 1
               }
           } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: val)
           {
               years = years - 1
               months = 11
           }
           
           //Calculate the days
           if cal.component(.day, from: Date()) > cal.component(.day, from: val){
               days = cal.component(.day, from: Date()) - cal.component(.day, from: val)
           }
           else if cal.component(.day, from: Date()) < cal.component(.day, from: val)
           {
               let today = cal.component(.day, from: Date())
               let date = cal.date(byAdding: .month, value: -1, to: Date())
               
               days = date!.daysInMonth - cal.component(.day, from: val) + today
           } else
           {
               days = 0
               if months == 12
               {
                   years = years + 1
                   months = 0
               }
           }
           
           return (years, months, days)
       }
       
}
