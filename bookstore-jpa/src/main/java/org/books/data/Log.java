package org.books.data;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Temporal;

import static javax.persistence.GenerationType.IDENTITY;
import static javax.persistence.TemporalType.TIMESTAMP;

@Entity
public class Log implements Serializable {

	@Id
	@GeneratedValue(strategy = IDENTITY)
	private Long id;
	@Temporal(TIMESTAMP)
	private Date logtime;
	private String message;

	public Log() {
	}

	public Log(String message) {
		logtime = new Date();
		this.message = message;
	}

	public Long getId() {
		return id;
	}

	public Date getTimestamp() {
		return logtime;
	}

	public String getMessage() {
		return message;
	}
}
