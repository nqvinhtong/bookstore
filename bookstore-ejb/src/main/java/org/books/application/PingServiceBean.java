package org.books.application;

import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import org.books.data.Log;
import org.books.persistence.LogDAO;

@Stateless(name = "PingService")
public class PingServiceBean implements PingService {

	private static final Logger logger = Logger.getLogger(PingServiceBean.class.getName());

	@EJB
	private LogDAO logDAO;

	@Override
	public String ping() {
		logger.log(Level.INFO, "Ping");
		logDAO.persist(new Log("Ping"));
		return "Hello (" + new Date() + ")";
	}
}
