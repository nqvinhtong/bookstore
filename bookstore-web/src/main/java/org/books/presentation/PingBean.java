package org.books.presentation;

import java.io.Serializable;
import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.inject.Named;
import org.books.application.PingService;

@Named
@RequestScoped
public class PingBean implements Serializable {

	@EJB
	private PingService pingService;
	private String message;

	public String getMessage() {
		return message;
	}

	public void ping() {
		message = pingService.ping();
	}
}
