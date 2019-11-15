import java.io.{BufferedWriter, File, FileWriter}

import com.github.tototoshi.csv._
import spray.json._
import DefaultJsonProtocol._
import com.github.javafaker.Faker

import scala.util.Random



case class Profile (color: Option[String], job: Option[String],
                    phoneNumber: Option[String], nation: Option[String])

object ProfileJsonProtocol extends DefaultJsonProtocol {
  implicit val sthFormat = jsonFormat4(Profile)
}



object Main extends App {
  println("GG")
  val random = new Random
  val faker = new Faker

  //scores.csv
  val f1 = new File("/home/ubuntu/SQL_HOMETASK/scores.csv")
  val writer1 = CSVWriter.open(f1)
  //val csvSchema = Array("Score_ID", "Score", "USER_ID", "Event_ID", "Comments")

  val score_values = (1 to 10).toList
  //val users_id = (1 until 1000000).toList
  //val events_range = (1 to 1000000).toList
  var events_array = Array.ofDim[Int](1000000, 2)

  for (i <- 0 until 1000000; j <- 0 until 2) {
    events_array(i)(j) = 0
  }

  for (i <- 0 until 100000000) {
    val event_id = random.nextInt(1000000)
    val score_value = score_values(random.nextInt(score_values.length))
    events_array(event_id)(0) = events_array(event_id)(0) + score_value
    events_array(event_id)(1) = events_array(event_id)(1) + 1


    writer1.writeRow(List(i, score_value,
      random.nextInt(1000000),
      event_id,
      Map("comment1" -> faker.lebowski.actor(), "comment2" -> faker.finance().creditCard()).toJson))
  }
  writer1.close()


  //users.csv
  //val csvSchema = Array(User_ID, First_name, Last_name, City_ID, User_prof)

  val f2 = new File("/home/ubuntu/SQL_HOMETASK/users.csv")
  val writer2 = CSVWriter.open(f2)


  val cities_id = (0 to 10).toList

  
  import ProfileJsonProtocol._
  for (i <- 0 until 1000000) {
    writer2.writeRow(List(i, faker.name().firstName(), faker.name().lastName(),
      random.nextInt(cities_id.length),
      Profile(Seq(Some(faker.color().name()), None)(random.nextInt(2)),
              Seq(Some(faker.job.title()), None)(random.nextInt(2)),
              Seq(Some(faker.phoneNumber.phoneNumber()),
                  Some(faker.phoneNumber.phoneNumber()), None)(random.nextInt(3)),
                  Some(faker.nation.nationality())).toJson))
  }
  writer2.close()



  //KVN_Events.csv
  val f3 = new File("/home/ubuntu/SQL_HOMETASK/KVN_Events.csv")
  val writer3 = CSVWriter.open(f3)

  //val csvSchema = Array(Event_ID, Event_name,
  // Description, Game_ID, Amount_scores, Average_score, Teams, Event_type)

  for (i <- 0 until 1000000) {
    writer3.writeRow(List(i, faker.esports.event(), faker.starTrek.specie(),
      random.nextInt(10),
      events_array(i)(1),
      if (events_array(i)(1) != 0) events_array(i)(0) / events_array(i)(1) else 0.0,
      "{1, 2}", 1))
  }
  writer3.close()
}
