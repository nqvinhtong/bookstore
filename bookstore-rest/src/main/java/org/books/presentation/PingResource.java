package org.books.presentation;

import javax.ejb.EJB;
import javax.enterprise.context.RequestScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import org.books.application.PingService;

@Path("ping")
@RequestScoped
public class PingResource {

	@EJB
	private PingService pingService;

	@GET
	public String ping() {
		return pingService.ping();
	}
}
