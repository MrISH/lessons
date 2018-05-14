import React from "react"
import logo from './open-book.svg';
import './Report.css';
import PropTypes from "prop-types"

class ReportHeader extends React.Component {

  constructor(props){
    super(props)
    this.state = {
      title: PropTypes.string,
      teacher: PropTypes.string
    }
  }

  componentDidMount() {
    this.setState({
      title: 'Student Report',
      teacher: sessionStorage.getItem('teacherName')
    })
  }

  render() {
    return (
      <div className="Report">
        <header className="Report-header">
          <img src={logo} className="Report-logo" alt="logo" />
          <h1 className="Report-title">{this.state.title}</h1>
          <h2 className="Report-teacher">{this.state.teacher}</h2>
        </header>
      </div>
    )
  }

}

export default ReportHeader;
