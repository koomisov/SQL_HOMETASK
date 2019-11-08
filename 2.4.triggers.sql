CREATE FUNCTION aver_fill() RETURNS trigger AS $aver_fill$
    BEGIN
        IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT' AND EXISTS (SELECT * FROM Jury_results AS J
            WHERE  J.Team_ID = NEW.Team_ID
            AND   J.Event_ID = NEW.Event_ID LIMIT 1)) THEN
                UPDATE Teams_events SET Integral_jury_score = N.averg
                FROM 
                (SELECT Team_ID, Event_ID, ROUND(AVG(J_score), 1) AS averg 
                FROM Jury_results AS J GROUP BY Team_ID, Event_ID
                HAVING J.Team_ID = NEW.Team_ID
                AND   J.Event_ID = NEW.Event_ID) AS N
                WHERE Teams_events.Team_ID = N.Team_ID
                AND Teams_events.Event_ID = N.Event_ID;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO Teams_events (Team_ID, Event_ID, Integral_jury_score) VALUES
            	(NEW.Team_ID, NEW.Event_ID, NEW.J_score);
        ELSIF (TG_OP = 'DELETE') THEN
            IF (EXISTS (SELECT * FROM Jury_results AS J
            WHERE  J.Team_ID = OLD.Team_ID
            AND   J.Event_ID = OLD.Event_ID LIMIT 1)) THEN
                UPDATE Teams_events SET Integral_jury_score = N.averg
                FROM 
                (SELECT Team_ID, Event_ID, ROUND(AVG(J_score), 1) AS averg 
                FROM Jury_results AS J GROUP BY Team_ID, Event_ID
                HAVING J.Team_ID = OLD.Team_ID
                AND   J.Event_ID = OLD.Event_ID) AS N
                WHERE Teams_events.Team_ID = N.Team_ID
                AND Teams_events.Event_ID = N.Event_ID;
            ELSE
                UPDATE Teams_events SET Integral_jury_score = 0.0
                WHERE Teams_events.Team_ID = OLD.Team_ID AND Teams_events.Event_ID = OLD.Event_ID;
            END IF;
        END IF;
        RETURN NULL;
    END;
$aver_fill$ LANGUAGE plpgsql;

CREATE TRIGGER aver_fill 
AFTER INSERT OR UPDATE OR DELETE ON Jury_results 
FOR EACH ROW EXECUTE FUNCTION aver_fill();



CREATE FUNCTION prohibit_change() RETURNS trigger AS $prohibit_change$
    BEGIN
        RAISE NOTICE 'Don`t touch it';
        IF (TG_OP = 'DELETE') THEN
            RETURN OLD;
        ELSE 
            RETURN NEW;
        END IF;
    END;
$prohibit_change$ LANGUAGE plpgsql;

CREATE TRIGGER prohibit_change
BEFORE INSERT OR UPDATE OR DELETE ON Teams_events
FOR EACH STATEMENT EXECUTE FUNCTION prohibit_change();
