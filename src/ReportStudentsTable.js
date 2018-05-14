import React from "react"
import PropTypes from "prop-types"
import axios from "axios"

// const csrfToken = document.querySelector("meta[name=csrf-token]").content
// axios.defaults.headers.common['X-CSRF-Token'] = csrfToken

class ReportStudentsTable extends React.Component {

  constructor(props){
    super(props)
    this.state = {
      students: [],
    }
  }

  componentDidMount() {
    axios.get('http://localhost:3000/api/v1/students/report?teacher_id=1')
    .then(response => {
      this.setState({
        students: response.data.students
      })
    })
    .catch(error => console.log(error))
  }

  render() {
    const students    = this.state.students
    const studentRows = students.map(student => {
      return (
        <tr key = {student.id}>
          <td>
            {student.id}
          </td>
          <td>
            {student.first_name} {student.last_name}
          </td>
          <td>
            L{student.highest_lesson_progress.lesson_number} P{student.highest_lesson_progress.lesson_part_number}
          </td>
        </tr>
      )
    })

    return (
      <table className="Report-StudentsTable">
        <thead>
          <tr>
            <th>ID</th>
            <th>Student Name</th>
            <th>Lesson Progress</th>
          </tr>
        </thead>
        <tbody>
          {studentRows}
        </tbody>
      </table>
    )
  }

}

export default ReportStudentsTable;
