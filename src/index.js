import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import ReportHeader from './ReportHeader';
import ReportStudentsTable from './ReportStudentsTable';
import registerServiceWorker from './registerServiceWorker';

ReactDOM.render(<ReportHeader />, document.getElementById('header'));
ReactDOM.render(<ReportStudentsTable />, document.getElementById('studentsTable'));

registerServiceWorker();
